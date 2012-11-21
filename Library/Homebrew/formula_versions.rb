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
      path.realpath.relative_path_from HOMEBREW_REPOSITORY
    else
      path.realpath
    end
  end

  def sha_for_version version
    rev_list.find{ |sha| version == version_for_sha(sha) }
  end

  def text_from_sha sha
    repository.cd do
      `git cat-file blob #{sha}:#{path.realpath.relative_path_from repository}`
    end
  end

  private
    def rev_list
      repository.cd do
        `git rev-list HEAD -- #{path.realpath.relative_path_from repository}`.split
      end
    end

    def version_for_sha sha
      mktemp do
        path = Pathname.new(Pathname.pwd+"#{name}.rb")
        path.write text_from_sha(sha)

        # Unload the class so Formula#version returns the correct value
        # FIXME shouldn't have to do this?
        begin
          version = nostdout { Formula.factory(path).version }
          Object.send(:remove_const, Formula.class_s(name))
          version.to_s
        rescue SyntaxError, TypeError, NameError, ArgumentError
          # We rescue these so that we can skip bad versions and
          # continue walking the history
          nil
        end
      end
    end
end