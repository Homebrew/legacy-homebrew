#!/usr/bin/ruby
# This software is in the public domain, furnished "as is", without technical
# support, and with no warranty, express or implied, as to its usefulness for
# any purpose.

$:.unshift File.dirname(__FILE__)+'/..'
require 'test/unit'
require 'global'
require 'formula'
require 'utils'


# NOTE duplicated in unittest.rb (we need to refactor the tests anyway)
def nostdout
  if ARGV.include? '-V'
    yield
  end
  begin
    require 'stringio'
    tmpo=$stdout
    tmpe=$stderr
    $stdout=StringIO.new
    yield
  ensure
    $stdout=tmpo
  end
end


class FormulaNames <Test::Unit::TestCase
  def test_formula_names
    nostdout do
      Dir["#{HOMEBREW_PREFIX}/Library/Formula/*.rb"].each do |f|
        assert_nothing_raised do
          Formula.factory f
        end
      end
    end
  end
end

class CommentedTemplateCode <Test::Unit::TestCase
  def test_for_commented_out_cmake
    Dir["#{HOMEBREW_PREFIX}/Library/Formula/*.rb"].each do |f|
      result = `grep "# depends_on 'cmake'" "#{f}"`.strip
      assert_equal('', result, "Commented template code still in #{f}")
    end
  end
end