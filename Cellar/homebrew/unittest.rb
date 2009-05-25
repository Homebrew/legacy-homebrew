#!/usr/bin/ruby
cwd=File.dirname(__FILE__)
$:.unshift cwd #rubysucks
require 'brewkit'
require 'test/unit'
$cellar=Pathname.new(cwd).parent.realpath

class BeerTasting < Test::Unit::TestCase
  def test_version_all_dots
    r=Formula.new "http://example.com/foo.bar.la.1.14.zip", 'nomd5'
    assert_equal '1.14', r.version
  end

  def test_version_underscore_separator
    r=Formula.new "http://example.com/grc_1.1.tar.gz", 'nomd5'
    assert_equal '1.1', r.version
  end

  def test_version_underscores_all_the_way
    r=Formula.new "http://example.com/boost_1_39_0.tar.bz2", 'nomd5'
    assert_equal '1.39.0', r.version
  end

  def test_version_internal_dash
    r=Formula.new "http://example.com/foo-arse-1.1-2.tar.gz", 'nomd5'
    assert_equal '1.1-2', r.version
  end

  def test_version_single_digit
    r=Formula.new "http://example.com/foo_bar.45.tar.gz", 'nomd5'
    assert_equal '45', r.version
  end

  def test_noseparator_single_digit
    r=Formula.new "http://example.com/foo_bar45.tar.gz", 'nomd5'
    assert_equal '45', r.version
  end

  def test_version_developer_that_hates_us_format
    r=Formula.new "http://example.com/foo-bar-la.1.2.3.tar.gz", 'nomd5'
    assert_equal '1.2.3', r.version
  end

  def test_version_regular
    r=Formula.new "http://example.com/foo_bar-1.21.tar.gz", 'nomd5'
    assert_equal '1.21', r.version
  end

  def test_prefix
    url='http://www.methylblue.com/test-0.1.tar.gz'
    md5='d496ea538a21dc4bb8524a8888baf88c'
    
    begin #rubysyntaxFAIL
      Formula.new(url, md5).brew do |prefix|
        # we test for +/unittest/0.1 because we derive @name from $0
        assert_equal File.expand_path(prefix), ($cellar+'unittest'+'0.1').to_s
        assert_kind_of Pathname, prefix
      end
    rescue IOError => e
      # this is not an error, cook will throw as nothing was installed
      raise unless e.errno == Errno::ENOENT
    end
  end
end