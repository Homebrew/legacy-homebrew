class RefreshBrew
  CHECKOUT_COMMAND = 'git checkout masterbrew'
  UPDATE_COMMAND   = 'git pull origin masterbrew'
  REVISION_COMMAND = 'git log -l -1 --pretty=format:%H'
  GIT_UP_TO_DATE   = 'Already up-to-date.'
  UPDATED_FORMULA  = %r{^\s+Library/Formula/(.+?)\.rb\s}
  
  attr_reader :updated_formulae
  
  def initialize
    @updated_formulae = []
  end
  
  # Performs an update of the homebrew source. Returns +true+ if a newer
  # version was available, +false+ if already up-to-date.
  def update_from_masterbrew!
    git_checkout_masterbrew!
    output = git_pull!
    output.split("\n").each do |line|
      @updated_formulae << $1 if line =~ UPDATED_FORMULA
    end
    output.strip != GIT_UP_TO_DATE
  end
  
  def pending_formulae_changes?
    !@updated_formulae.empty?
  end
  
  def current_revision
    in_prefix { execute(REVISION_COMMAND).strip }
  end
  
  private
  
  def in_prefix
    Dir.chdir(HOMEBREW_PREFIX) { yield }
  end
  
  def execute(cmd)
    out = `#{cmd}`
    if ARGV.verbose?
      ohai cmd
      puts out
    end
    out
  end
  
  def git_checkout_masterbrew!
    in_prefix { execute CHECKOUT_COMMAND }
  end
  
  def git_pull!
    in_prefix { execute UPDATE_COMMAND }
  end
end