# -*- coding: UTF-8 -*-

require "testing_env"
require "language/go"

class LanguageGoTests < Homebrew::TestCase
  def test_stage_deps_empty
    Language::Go.expects(:opoo).once
    mktmpdir do |path|
      shutup { Language::Go.stage_deps [], path }
    end
  end
end
