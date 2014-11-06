# encoding: UTF-8
#--
# This file is automatically generated. Do not modify it.
# Generated by: oedipus_lex version 2.4.0.
# Source: lib/praat_lexer.rex
#++

module Praat; end

class Praat::Lexer
  require 'strscan'

  INTEGER = /\d+/
  FLOAT   = /\d+\.\d+/
  NUMBER  = /#{FLOAT}|#{INTEGER}/
  WORD    = /[A-Za-z]+ ?[A-Za-z]*/

  class ScanError < StandardError ; end

  attr_accessor :filename
  attr_accessor :ss
  attr_accessor :state

  alias :match :ss

  def matches
    m = (1..9).map { |i| ss[i] }
    m.pop until m[-1] or m.empty?
    m
  end

  def action
    yield
  end


  def scanner_class
    StringScanner
  end unless instance_methods(false).map(&:to_s).include?("scanner_class")

  def parse str
    self.ss     = scanner_class.new str
    self.state  ||= nil

    do_parse
  end

  def parse_file path
    self.filename = path
    open path do |f|
      parse f.read
    end
  end

  def next_token

    token = nil

    until ss.eos? or token do
      token =
        case state
        when nil then
          case
          when text = ss.scan(/(#{WORD}) = (#{FLOAT})/) then
            action { [:float_property, *matches] }
          when text = ss.scan(/(#{WORD}) = (#{INTEGER})/) then
            action { [:integer_property, *matches] }
          when text = ss.scan(/(#{WORD}) = "(#{WORD})"/) then
            action { [:string_property, *matches] }
          when text = ss.scan(/(#{WORD}) \[\]:/) then
            action { [:collection, *matches] }
          when text = ss.scan(/(#{WORD}) \[(#{INTEGER})\]/) then
            action { [:object, *matches] }
          when text = ss.scan(/\s+/) then
            # do nothing
          when text = ss.scan(/.*\n/) then
            # do nothing
          else
            text = ss.string[ss.pos .. -1]
            raise ScanError, "can not match (#{state.inspect}): '#{text}'"
          end
        else
          raise ScanError, "undefined state: '#{state}'"
        end # token = case state

      next unless token # allow functions to trigger redo w/ nil
    end # while

    raise "bad lexical result: #{token.inspect}" unless
      token.nil? || (Array === token && token.size >= 2)

    # auto-switch state
    self.state = token.last if token && token.first == :state

    token
  end # def next_token
end # class

  # vim: filetype=ruby