require 'formula'

module Homebrew extend self

  module Versions

    # The commit SHA for a specific version of a formula
    def self.sha_for name, version
      shas_for(name).each do |sha|
        return sha if version == version_for(name, sha)
      end

      nil
    end

    # All SHAs of the commits the named formula has been changed in
    def self.shas_for name
      `git --git-dir=#{HOMEBREW_REPOSITORY}/.git rev-list HEAD^ -- Library/Formula/#{name}.rb`.split
    end

    # Returns the version number for the named formula and the given commit SHA
    def self.version_for name, sha
      code = `git --git-dir=#{HOMEBREW_REPOSITORY}/.git show #{sha}:Library/Formula/#{name}.rb`
      version = code.match(/class #{Formula.class_s name} < ?Formula.*?(?:version\s|@version\s*=)\s*(?:'|")(.+?)(?:'|").*?end\s/m)
      if version.nil?
        url = code.match(/class #{Formula.class_s name} < ?Formula.*?(?:url\s|@url\s*=)\s*(?:'|")(.+?)(?:'|").*?end\s/m)
        if url.nil?
          head = code.match(/class #{Formula.class_s name} < ?Formula.*?head\s'(.*?)'.*?end\s\s/m)
          if head.nil?
            opoo "Version of #{name} could not be determined for #{sha}."
            nil
          else
            'HEAD'
          end
        else
          Pathname.new(url[1]).version
        end
      else
        version[1]
      end
    end

    # All older versions of a formula together with the SHA of their most recent
    # revision
    def self.old_versions(formula)
      old_versions = []

      shas_for(formula.name).each do |sha|
        old_version = version_for formula.name, sha

        if old_version != formula.version &&
           (old_versions.empty? || old_version != old_versions.last[0])
          old_versions << [old_version, sha]
        end
      end

      old_versions
    end

  end

  def versions
    puts "Listing older versions for: #{ARGV.formulae.join(', ')}"

    puts <<-EOS.undent

      If you want to install one of these old versions run `git reset --hard
      $COMMIT_ID_OF_VERSION` in "#{HOMEBREW_REPOSITORY}". After that you can install the formula
      like usual with `brew install formula`. When you're done use `git reset --hard
      master@{1}` in "#{HOMEBREW_REPOSITORY}" to get back to the most recent versions again.

      WARNING: This also reverts Homebrew itself to an old revision. This may lead to
      broken installations and/or not being able to install an old formula at all.
    EOS

    ARGV.formulae.all? do |f|
      old_versions = Versions.old_versions f

      if old_versions.empty?
        puts "\nThere are no older versions for \"#{f.name}\" (current: #{f.version})."
      else
        puts "\nOlder versions for \"#{f.name}\" (current: #{f.version}):\n"

        max_size = 0
        old_versions.each { |v| max_size = v[0].size if v[0].size > max_size }
        old_versions.each { |v| puts '  %s (%s)' % [v[0].ljust(max_size), v[1]] }
      end
    end
  end

end
