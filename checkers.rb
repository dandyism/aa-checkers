#!/usr/bin/env ruby

require_relative 'board'
require_relative 'human_player'
require_relative 'remote_player'

require "optparse"

class Checkers
  
  def initialize
    self.board = Board.new
  end
  
  def init_hotseat
    self.players = [
      HumanPlayer.new(self.board, :light),
      HumanPlayer.new(self.board, :dark)
    ]
  end
  
  def init_server
    self.players = [
      HumanPlayer.new(self.board, :light),
      RemotePlayer.new(self.board, :dark)
    ]
  end
  
  def init_remote(address)
    self.players = [
      RemotePlayer.new(self.board, :light, address),
      HumanPlayer.new(self.board, :dark)
    ]
  end
  
  def play
    
    until over?
      current_player = self.players.first
      self.board.render
      
      begin
        move = current_player.take_turn        
        
        if self.players.last.is_a?(RemotePlayer)
          self.players.last.send_move(move)
        end
        
      rescue InvalidMoveError, ArgumentError
        puts "Invalid Move!"
        retry
      rescue Interrupt
        puts "\rQuitting game"
        exit
      end
      
      self.players.rotate!
    end
    
    self.board.render
    winner = winner? || "No one"
    puts "#{winner} has won."
    
  end
  
  def over?
    self.players.any? { |player| player.defeated? }
  end
  
  def winner?
    self.players.find { |player| !player.defeated? }
  end
  
  protected
  attr_accessor :board, :players
  
end

if __FILE__ == $PROGRAM_NAME
  game = Checkers.new
  
  multiplayer = false
  remote_address = nil
  
  OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options]"
    
    opts.on("-m", "--multiplayer [address]",
                  "Omit [address] to start a local server.") do |address|
      multiplayer    = true
      remote_address = address
    end
  end.parse!
  
  if multiplayer 
    if remote_address.nil?
      game.init_server
    else
      game.init_remote(remote_address)
    end
    
  else
    game.init_hotseat
  end
  
  game.play
end
