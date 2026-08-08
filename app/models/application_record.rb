class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  @@BANNED_IDENTIFIERS = ['family', 'user', 'username', 'name', 'you', 'me', 'guest', 'account', 'admin', 'administrator', 'system', 'cooperative[ -]?surprise', 'help', 'error', 'blocked', 'deleted', 'password', ' ']
  @@NO_BREAK_SPACE = "\u00A0"
  @@LEFT_TO_RIGHT_MARK = "\u200E"
  @@RIGHT_TO_LEFT_MARK = "\u200F"
  @@ARABIC_LETTER_MARK = "\u061C"
  @@BANNED_IDENTIFIER_CHARS = [@@NO_BREAK_SPACE, @@LEFT_TO_RIGHT_MARK, @@RIGHT_TO_LEFT_MARK, @@ARABIC_LETTER_MARK]

  # Inspired by https://xkcd.com/1963/
  def self.validate_identifier(attribute, **validate_options)
    validate(**validate_options) do
      identifier = public_send(attribute)
      @@BANNED_IDENTIFIERS.each do | banned_id |
        if /^#{banned_id}$/i.match? identifier
          errors.add attribute, :banned, message: 'is banned'
        end
      end
      @@BANNED_IDENTIFIER_CHARS.each do | banned_char |
        if identifier.include? banned_char
          errors.add attribute, :banned, message: 'contains banned characters'
        end
      end
      true
    end
  end

  attr_reader :BANNED_IDENTIFIERS, :BANNED_IDENTIFIER_CHARS
end
