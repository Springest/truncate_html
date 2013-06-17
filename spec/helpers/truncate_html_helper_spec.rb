# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
require 'active_support/core_ext/benchmark'

describe NokogiriTruncateHtml::TruncateHtmlHelper do
  include NokogiriTruncateHtml::TruncateHtmlHelper

  describe "examples from Rails doc" do
    it "'Once upon a time in a world far far away'" do
      truncate_html("Once upon a time in a world far far away").should == "Once upon a time in a world fa&hellip;"
    end

    it "'Once upon a time in a world far far away', :length => 14" do
      truncate_html("Once upon a time in a world far far away", :length => 14).should == "Once upon a ti&hellip;"
    end

    it "'And they found that many people were sleeping better.', :length => 25, :omission => '(clipped)'" do
      truncate_html("And they found that many people were sleeping better.", :length => 25, :omission => "(clipped)").should == "And they found that many (clipped)"
    end
  end

  describe "use cases" do
    def self.with_length_should_equal(n, str)
      it "#{n}, should equal #{str}" do
        truncate_html(@html, :length => n).should == str
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

  it "should not convert ' to &apos; (html4 compat)" do
    truncate_html("30's").should == "30's"
  end

  describe 'benchmark' do
    let(:test_string) { File.read('spec/fixtures/index.html') }
    subject { Benchmark.ms { 100.times { |a| truncate_html(test_string, length: a*50) } } / 100 }
    it 'is faster than 1.5ms' do
      should be < 1.5
    end
  end
end
