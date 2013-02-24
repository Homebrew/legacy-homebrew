require 'irb'

module IRB
  @setup_done = false

  def IRB.start_within(binding)
    unless @setup_done
      # make IRB ignore our command line arguments
      begin
        saved_args = ARGV.shift(ARGV.size)
        IRB.setup(nil)
      ensure
        ARGV.replace(saved_args)
      end
      @setup_done = true
    end

    workspace = WorkSpace.new(binding)
    irb = Irb.new(workspace)

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    trap("SIGINT") do
      irb.signal_handle
    end

    begin
      catch(:IRB_EXIT) do
        irb.eval_input
      end
    ensure
      irb_at_exit
    end
  end
end
