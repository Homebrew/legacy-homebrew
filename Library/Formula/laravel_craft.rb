require "formula"

class LaravelCraft < Formula
  homepage "http://laravel.com/docs/quick#installation"
  url "http://laravel.com/laravel.phar"
  sha1 "705d922665dceac5f266920f7d11ebec7150b747"
  version "1.0.0"

  def install
    system "mv", "laravel.phar", "/usr/local/bin/laravel"
    system "chmod", "u+x", "/usr/local/bin/laravel"
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'Laravel Craft version 1.0.0', `#{bin}/laravel --version`.strip
    end
  end

end
