require 'formula'

module Homebrew extend self
  def versions
    raise "Please `brew install git` first" unless which "git"
    raise "Please `brew update' first" unless (HOMEBREW_REPOSITORY/".git").directory?

    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.all? do |f|
      if ARGV.include? '--compact'
        puts f.versions * " "
      else
        f.versions do |version, sha|
          print Tty.white.to_s
          print "#{version.to_s.ljust(8)} "
          print Tty.reset.to_s
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
    if Pathname.pwd == repository
      entry_name
    else
      repository/"#{entry_name}"
    end
  end

  private
    def repository
      @repository ||= begin
        if path.realpath.to_s =~ %r{#{HOMEBREW_REPOSITORY}/Library/Taps/(\w+)-(\w+)}
          HOMEBREW_REPOSITORY/"Library/Taps/#$1-#$2"
        else
          HOMEBREW_REPOSITORY
        end
      end
    end

    def entry_name
      @entry_name ||= begin
        repository == HOMEBREW_REPOSITORY ? "Library/Formula/#{name}.rb" : "#{name}.rb"
      end
    end

    def rev_list
      repository.cd do
        `git rev-list --abbrev-commit HEAD -- #{entry_name}`.split
      end
    end

    def text_from_sha sha
      repository.cd do
        `git cat-file blob #{sha}:#{entry_name}`
      end
    end

    def sha_for_version version
      rev_list.find{ |sha| version == version_for_sha(sha) }
    end

    IGNORED_EXCEPTIONS = [SyntaxError, TypeError, NameError,
                          ArgumentError, FormulaSpecificationError]

    def version_for_sha sha
      mktemp do
        path = Pathname.new(Pathname.pwd+"#{name}.rb")
        path.write text_from_sha(sha)

        # Unload the class so Formula#version returns the correct value
        begin
          Formulary.unload_formula name
          nostdout { Formula.factory(path.to_s).version }
        rescue *IGNORED_EXCEPTIONS => e
          # We rescue these so that we can skip bad versions and
          # continue walking the history
          ohai "#{e} in #{name} at revision #{sha}", e.backtrace if ARGV.debug?
        end
      end
    end
end
