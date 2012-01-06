require 'formula'

module Homebrew extend self
  def versions
    raise "Please `brew install git` first" unless system "/usr/bin/which -s git"

    ARGV.formulae.all? do |f|
      if ARGV.include? '--compact'
        puts f.versions * " "
      else
        f.versions do |version, sha|
          print Tty.white
          print "#{version.ljust(8)} "
          print Tty.reset
          puts "git checkout #{sha} #{f.pretty_relative_path}"
        end
      end
    end
  end
end


class Formula
  def versions
    versions = []
    rev_list.each do |sha|
      version = version_for_sha sha
      unless versions.include? version or version.nil?
        yield version, sha if block_given?
        versions << version
      end
    end
    return versions
  end

  def pretty_relative_path
    if Pathname.pwd == HOMEBREW_REPOSITORY
      "Library/Formula/#{name}.rb"
    else
      "#{HOMEBREW_REPOSITORY}/Library/Formula/#{name}.rb"
    end
  end

  private
    def rev_list
      HOMEBREW_REPOSITORY.cd do
        `git rev-list --abbrev-commit HEAD -- Library/Formula/#{name}.rb`.split
      end
    end

    def text_from_sha sha
      HOMEBREW_REPOSITORY.cd do
        `git cat-file blob #{sha}:Library/Formula/#{name}.rb`
      end
    end

    def sha_for_version version
      rev_list.find{ |sha| version == version_for_sha(sha) }
    end

    def version_for_sha sha
      mktemp do
        path = Pathname.new(Pathname.pwd+"#{name}.rb")
        path.write text_from_sha(sha)
        Formula.factory(path).version
      end rescue nil
    end
end
