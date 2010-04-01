#!/usr/bin/ruby
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

$:.push(File.expand_path(__FILE__+'/../..'))
require 'test/unit'
require 'global'
require 'formula'
require 'utils'


class WellKnownCodeIssues <Test::Unit::TestCase
  def test_formula_names
    # Formula names should be valid
    nostdout do
      Dir["#{HOMEBREW_PREFIX}/Library/Formula/*.rb"].each do |f|
        assert_nothing_raised do
          Formula.factory f
        end
      end
    end
  end

  def test_for_commented_out_cmake
    # Formulas shouldn't contain commented-out cmake code from the default template
    Formulary.paths.each do |f|
      result = `grep "# depends_on 'cmake'" "#{f}"`.strip
      assert_equal('', result, "Commented template code still in #{f}")
    end
  end
  
  def test_for_misquoted_prefix
    # Prefix should not have single quotes if the system args are already separated
    target_string = "[\\\"]--prefix=[\\']"
    
    Formulary.paths.each do |f|
      result = `grep -e "#{target_string}" "#{f}"`.strip
      assert_equal('', result, "--prefix is incorrectly single-quoted in #{f}")
    end
  end
  
  def test_for_crufy_sourceforge_url
    # Don't specify mirror for SourceForge downloads
    Formulary.paths.each do |f|
      result = `grep "\?use_mirror=" "#{f}"`.strip
      assert_equal('', result, "Remove 'use_mirror' from url for #{f}")
    end
  end
end
