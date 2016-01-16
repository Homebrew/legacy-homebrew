require "formula"

class FormulaVersions
  IGNORED_EXCEPTIONS = [
    ArgumentError, NameError, SyntaxError, TypeError,
    FormulaSpecificationError, FormulaValidationError,
    ErrorDuringExecution, LoadError
  ]

  attr_reader :name, :path, :repository, :entry_name

  def initialize(formula, options = {})
    @name = formula.name
    @path = formula.path
    @repository = formula.tap.path
    @entry_name = @path.relative_path_from(repository).to_s
    @max_depth = options[:max_depth]
  end

  def rev_list(branch)
    repository.cd do
      depth = 0
      Utils.popen_read("git", "rev-list", "--abbrev-commit", "--remove-empty", branch, "--", entry_name) do |io|
        yield io.readline.chomp until io.eof? || (@max_depth && (depth += 1) > @max_depth)
      end
    end
  end

  def file_contents_at_revision(rev)
    repository.cd { Utils.popen_read("git", "cat-file", "blob", "#{rev}:#{entry_name}") }
  end

  def formula_at_revision(rev)
    contents = file_contents_at_revision(rev)

    begin
      nostdout { yield Formulary.from_contents(name, path, contents) }
    rescue *IGNORED_EXCEPTIONS => e
      # We rescue these so that we can skip bad versions and
      # continue walking the history
      ohai "#{e} in #{name} at revision #{rev}", e.backtrace if ARGV.debug?
    rescue FormulaUnavailableError
      # Suppress this error
    end
  end

  def bottle_version_map(branch)
    map = Hash.new { |h, k| h[k] = [] }
    rev_list(branch) do |rev|
      formula_at_revision(rev) do |f|
        bottle = f.bottle_specification
        unless bottle.checksums.empty?
          map[f.pkg_version] << bottle.revision
        end
      end
    end
    map
  end

  def revision_map(branch)
    map = Hash.new { |h, k| h[k] = [] }
    rev_list(branch) do |rev|
      formula_at_revision(rev) do |f|
        map[f.stable.version] << f.revision if f.stable
        map[f.devel.version] << f.revision if f.devel
      end
    end
    map
  end
end
