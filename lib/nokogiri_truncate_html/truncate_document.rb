# frozen_string_literal: true

require 'nokogiri'
require 'cgi'

module NokogiriTruncateHtml
  class TruncateDocument < Nokogiri::XML::SAX::Document
    def initialize
      @discard_first_element = false
    end

    attr_writer :length, :omission

    def output
      while @tags.size > 0
        @output << "</#{@tags.pop}>"
      end
      @output
    end

    def start_document
      @output, @chars_remaining, @tags = String.new, @length, []
      @discard_first_element = false
    end

    def characters(text)
      @output << CGI.escapeHTML(text[0, @chars_remaining])
      @chars_remaining -= text.length
      if @chars_remaining < 0
        @output << @omission
        throw :truncate_finished
      end
    end

    HTML_TAG = 'html'.freeze
    BODY_TAG = 'body'.freeze
    BR_TAG = 'br'.freeze
    EMBED_TAG = 'embed'.freeze
    HR_TAG = 'hr'.freeze
    IMG_TAG = 'img'.freeze
    INPUT_TAG = 'input'.freeze
    PARAM_TAG = 'param'.freeze

    def start_element(name, attrs = [])
      unless @discard_first_element
        return if name == HTML_TAG || name == BODY_TAG
        return @discard_first_element = true
      end

      @output << "<#{name}"
      unless attrs.empty?
        attrs.each do |attr, val|
          @output << " #{attr}=\"#{val}\""
        end
      end

      if name == BR_TAG || name == EMBED_TAG || name == HR_TAG ||
          name == IMG_TAG || name == INPUT_TAG || name == PARAM_TAG
        @output << ' />'
      else
        @output << '>'
        @tags.push name
      end
    end

    def end_element(name)
      @output << "</#{@tags.pop}>" if @tags.last == name
    end
  end
end
