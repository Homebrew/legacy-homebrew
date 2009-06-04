#!/usr/bin/ruby
require 'test/unit'
require "#{__FILE__}/../brewkit"

class TestFormula <Formula
  def initialize url, md5
    @url=url
    @md5=md5
    @name='test'
    super()
  end
end


class BeerTasting <Test::Unit::TestCase
  def test_version_all_dots
    r=TestFormula.new "http://example.com/foo.bar.la.1.14.zip", 'nomd5'
    assert_equal '1.14', r.version
  end

  def test_version_underscore_separator
    r=TestFormula.new "http://example.com/grc_1.1.tar.gz", 'nomd5'
    assert_equal '1.1', r.version
  end

  def test_version_underscores_all_the_way
    r=TestFormula.new "http://example.com/boost_1_39_0.tar.bz2", 'nomd5'
    assert_equal '1.39.0', r.version
  end

  def test_version_internal_dash
    r=TestFormula.new "http://example.com/foo-arse-1.1-2.tar.gz", 'nomd5'
    assert_equal '1.1-2', r.version
  end

  def test_version_single_digit
    r=TestFormula.new "http://example.com/foo_bar.45.tar.gz", 'nomd5'
    assert_equal '45', r.version
  end

  def test_noseparator_single_digit
    r=TestFormula.new "http://example.com/foo_bar45.tar.gz", 'nomd5'
    assert_equal '45', r.version
  end

  def test_version_developer_that_hates_us_format
    r=TestFormula.new "http://example.com/foo-bar-la.1.2.3.tar.gz", 'nomd5'
    assert_equal '1.2.3', r.version
  end

  def test_version_regular
    r=TestFormula.new "http://example.com/foo_bar-1.21.tar.gz", 'nomd5'
    assert_equal '1.21', r.version
  end

  def test_yet_another_version
    r=TestFormula.new "http://example.com/mad-0.15.1b.tar.gz", 'nomd5'
    assert_equal '0.15.1b', r.version
  end

  def test_prefix
    url='http://www.methylblue.com/test-0.1.tar.gz'
    md5='d496ea538a21dc4bb8524a8888baf88c'
    
    TestFormula.new(url, md5).brew do |f|
      prefix=f.prefix
      # we test for +/unittest/0.1 because we derive @name from $0
      assert_equal File.expand_path(prefix), ($cellar+'test'+'0.1').to_s
      assert_kind_of Pathname, prefix
    end
  end
end