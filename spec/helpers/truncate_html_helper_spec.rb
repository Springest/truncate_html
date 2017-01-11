# frozen_string_literal: true
require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require 'active_support/core_ext/benchmark'

describe NokogiriTruncateHtml::TruncateHtmlHelper do
  include NokogiriTruncateHtml::TruncateHtmlHelper

  describe "examples from Rails doc" do
    it "'Once upon a time in a world far far away'" do
      expect(truncate_html("Once upon a time in a world far far away")).to eq("Once upon a time in a world fa&hellip;")
    end

    it "'Once upon a time in a world far far away', :length => 14" do
      expect(truncate_html("Once upon a time in a world far far away", :length => 14)).to eq("Once upon a ti&hellip;")
    end

    it "'And they found that many people were sleeping better.', :length => 25, :omission => '(clipped)'" do
      expect(truncate_html("And they found that many people were sleeping better.", :length => 25, :omission => "(clipped)")).to eq("And they found that many (clipped)")
    end
  end

  describe "use cases" do
    def self.with_length_should_equal(n, str)
      it "#{n}, should equal #{str}" do
        expect(truncate_html(@html, :length => n)).to eq(str)
      end
    end

    describe "html: <p>Hello <strong>World</strong></p>, length: " do
      before { @html = '<p>Hello <strong>World</strong></p>' }

      with_length_should_equal 3, '<p>Hel&hellip;</p>'
      with_length_should_equal 7, '<p>Hello <strong>W&hellip;</strong></p>'
      with_length_should_equal 11, '<p>Hello <strong>World</strong></p>'
    end

    describe 'html: <p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>, length: ' do
      before { @html = '<p>Hello &amp; <span class="foo">Goodbye</span> <br /> Hi</p>' }

      with_length_should_equal 7, '<p>Hello &amp;&hellip;</p>'
      with_length_should_equal 9, '<p>Hello &amp; <span class="foo">G&hellip;</span></p>'
      with_length_should_equal 18, '<p>Hello &amp; <span class="foo">Goodbye</span> <br /> H&hellip;</p>'
    end

    describe '(incorrect) html: <p>Hello <strong>World</p><div>And Hi, length: ' do
      before { @html = '<p>Hello <strong>World</p><div>And Hi' }

      with_length_should_equal 10, '<p>Hello <strong>Worl&hellip;</strong></p>'
      with_length_should_equal 30, '<p>Hello <strong>World</strong></p><div>And Hi</div>'
    end
  end

  it "converts ' to &#39;" do
    expect(truncate_html("30's")).to eq("30&#39;s")
  end
end
