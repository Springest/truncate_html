require 'active_support/core_ext/module/attribute_accessors.rb'
require 'active_support/core_ext/string/output_safety'
require 'nokogiri_truncate_html/truncate_document'

module NokogiriTruncateHtml
  module TruncateHtmlHelper
    # Truncates html respecting tags and html entities.
    #
    # The API is the same as ActionView::Helpers::TextHelper#truncate. It uses Nokogiri and HtmlEntities for entity awareness.
    #
    # Examples:
    #  truncate_html '<p>Hello <strong>World</strong></p>', :length => 7 # => '<p>Hello <strong>W&hellip;</strong></p>'
    #  truncate_html '<p>Hello &amp; Goodbye</p>', :length => 7          # => '<p>Hello &amp;&hellip;</p>'
    def truncate_html(input, *args)
      document = truncate_html_document
      parser = truncate_html_parser

      # support both 2.2 & earlier APIs
      options = args.extract_options!
      length = options[:length] || args[0] || 30
      omission = options[:omission] || args[1] || '&hellip;'

      # Adding div around the input is a hack. It gets removed in TruncateDocument.
      input = "<div>#{input}</div>"
      document.length = length
      document.omission = omission
      catch(:truncate_finished) do
        parser.parse_memory(input)
      end
      document.output.html_safe
    end

    private

    def truncate_html_document
      Thread.current[:truncate_html_document] ||= TruncateDocument.new
    end

    def truncate_html_parser
      Thread.current[:truncate_html_parser] ||= Nokogiri::HTML::SAX::Parser.new(truncate_html_document)
    end
  end
end
