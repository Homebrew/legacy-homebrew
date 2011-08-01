module Homebrew extend self
  def update
    abort "Please `brew install git' first." unless system "/usr/bin/which -s git"

    updater = RefreshBrew.new
    if updater.update_from_masterbrew!
      updater.report
    else
      puts "Already up-to-date."
    end
  end
end

class RefreshBrew
  REPOSITORY_URL   = "http://github.com/mxcl/homebrew.git"
  CHECKOUT_COMMAND = "git checkout -q master"
  UPDATE_COMMAND   = "git pull #{REPOSITORY_URL} master"
  REVISION_COMMAND = "git rev-parse HEAD"
  DIFF_COMMAND     = "git diff-tree -r --name-status -z %s %s"

  FORMULA_DIR = 'Library/Formula/'
  EXAMPLE_DIR = 'Library/Contributions/examples/'

  attr_reader :added_formulae, :updated_formulae, :deleted_formulae, :installed_formulae
  attr_reader :added_examples, :updated_examples, :deleted_examples
  attr_reader :initial_revision, :current_revision

  def initialize
    @added_formulae, @updated_formulae, @deleted_formulae, @installed_formulae = [], [], [], []
    @added_examples, @updated_examples, @deleted_examples = [], [], []
    @initial_revision, @current_revision = nil
  end

  # Performs an update of the homebrew source. Returns +true+ if a newer
  # version was available, +false+ if already up-to-date.
  def update_from_masterbrew!
    HOMEBREW_REPOSITORY.cd do
      if git_repo?
        safe_system CHECKOUT_COMMAND
        @initial_revision = read_revision
      else
        begin
          safe_system "git init"
          safe_system "git fetch #{REPOSITORY_URL}"
          safe_system "git reset FETCH_HEAD"
        rescue Exception
          safe_system "rm -rf .git"
          raise
        end
      end
      execute(UPDATE_COMMAND)
      @current_revision = read_revision
    end

    if initial_revision && initial_revision != current_revision
      # hash with status characters for keys:
      # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)
      @changes_map = Hash.new {|h,k| h[k] = [] }

      changes = HOMEBREW_REPOSITORY.cd do
        execute(DIFF_COMMAND % [initial_revision, current_revision]).split("\0")
      end

      while status = changes.shift
        file = changes.shift
        @changes_map[status] << file
      end

      if @changes_map.any?
        @added_formulae   = changed_items('A', FORMULA_DIR)
        @deleted_formulae = changed_items('D', FORMULA_DIR)
        @updated_formulae = changed_items('M', FORMULA_DIR)
        @added_examples   = changed_items('A', EXAMPLE_DIR)
        @deleted_examples = changed_items('D', EXAMPLE_DIR)
        @updated_examples = changed_items('M', EXAMPLE_DIR)

        @installed_formulae = HOMEBREW_CELLAR.children.
          select{ |pn| pn.directory? }.
          map{ |pn| pn.basename.to_s }.sort if HOMEBREW_CELLAR.directory?

        return true
      end
    end
    # assume nothing was updated
    return false
  end

  def git_repo?
    Dir['.git/*'].length > 0
  end

  def pending_formulae_changes?
    !@updated_formulae.empty?
  end

  def pending_new_formulae?
    !@added_formulae.empty?
  end

  def deleted_formulae?
    !@deleted_formulae.empty?
  end

  def pending_examples_changes?
    !@updated_examples.empty?
  end

  def pending_new_examples?
    !@added_examples.empty?
  end

  def deleted_examples?
    !@deleted_examples.empty?
  end

  def report
    puts "Updated Homebrew from #{initial_revision[0,8]} to #{current_revision[0,8]}."
    ## New Formulae
    if pending_new_formulae?
      ohai "The following formulae are new:"
      puts_columns added_formulae
    end
    ## Deleted Formulae
    if deleted_formulae?
      ohai "The following formulae were removed:"
      puts_columns deleted_formulae, installed_formulae
    end
    ## Updated Formulae
    if pending_formulae_changes?
      ohai "The following formulae were updated:"
      puts_columns updated_formulae, installed_formulae
    end
    ## New examples
    if pending_new_examples?
      ohai "The following external commands are new:"
      puts_columns added_examples
    end
    ## Deleted examples
    if deleted_examples?
      ohai "The following external commands were removed:"
      puts_columns deleted_examples
    end
    ## Updated Formulae
    if pending_examples_changes?
      ohai "The following external commands were updated:"
      puts_columns updated_examples
    end
  end

  private

  def read_revision
    execute(REVISION_COMMAND).chomp
  end

  def filter_by_directory(files, dir)
    files.select { |f| f.index(dir) == 0 }
  end

  def basenames(files)
    files.map { |f| File.basename(f, '.rb') }
  end

  # extracts items by status from @changes_map
  def changed_items(status, dir)
    basenames(filter_by_directory(@changes_map[status], dir)).sort
  end

  def execute(cmd)
    out = `#{cmd}`
    if $? && !$?.success?
      $stderr.puts out
      raise "Failed while executing #{cmd}"
    end
    ohai(cmd, out) if ARGV.verbose?
    out
  end
end
