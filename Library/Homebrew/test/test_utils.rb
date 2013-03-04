require 'testing_env'

class UtilTests < Test::Unit::TestCase

  def setup
    FileUtils.mkdir_p HOMEBREW_CELLAR
    @sio = StdoutFake.new
    @stdout_tmp = $stdout.clone
  end

  def test_put_columns_empty
    assert_nothing_raised do
      # Issue #217 put columns with new results fails.
      puts_columns []
    end
  end

  def test_puts_columns
    $stdout = @sio
    l = ['red', 'green', 'greenwithstar', 'plain', 'star', 'yellow', 'blue', 'white']
    assert_nothing_raised do
      puts_columns l
      puts_columns ['']  # empty string
      puts_columns l, :star=>['spam']
    end
    assert_raise RuntimeError do
      puts_columns( l, :nonexistingspam => ['oops!'])
    end
    # We don't want to see the actual output. The real test comes below and
    # the `sio` was only used to provide a tty for puts_columns.
    @sio.reopen '', 'w+'
    puts
    puts "--------------------------------------------------------------------"
    puts "Now you should see a colored test output of the new puts_columns:"
    puts_columns l*8, :star=>['star', 'greenwithstar', 'thisisnotused'],
                      :green => ['green', 'greenwithstar'],
                      :red => ['red'],
                      :yellow => ['yellow'],
                      :white => ['white'],
                      :blue => ['blue']
    puts "\nAnd now a similar thing, sorted (column wise):"
    l << 'thelongestroad'
    sorted_l = l*3
    sorted_l.sort!
    puts_columns sorted_l, :star=>['star', 'greenwithstar', 'thisisnotused'],
                           :green => ['green', 'greenwithstar'],
                           :red => ['red'],
                           :yellow => ['yellow'],
                           :white => ['white'],
                           :blue => ['blue']

    puts "--------------------------------------------------------------------"
    $stdout = @stdout_tmp

    # Now if you want to see cool stuff, run with: `ruby test_utils.rb -- --verbose`
    shutup do
      @sio.seek 0
      puts @sio.read
    end
  end

  def test_arch_for_command
    archs = archs_for_command '/usr/bin/svn'
    if `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i >= 7
      assert_equal 2, archs.length
      assert archs.include?(:x86_64)
    elsif `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i == 6
      assert_equal 3, archs.length
      assert archs.include?(:x86_64)
      assert archs.include?(:ppc7400)
    else
      assert_equal 2, archs.length
      assert archs.include?(:ppc7400)
    end
    assert archs.include?(:i386)
  end

  def teardown
    # Let's have this last safty net
    if HOMEBREW_CELLAR.to_s.start_with? '/usr'
      raise "Now that was close! I am not going to delete anything in /usr"
    else
       HOMEBREW_CELLAR.rmtree
    end
  end
end
