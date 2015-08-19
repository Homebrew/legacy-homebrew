require "cmd/tap"

module Homebrew
  def tap_info
    if ARGV.include? "--installed"
      taps = Tap
    else
      taps = ARGV.named.map do |name|
        Tap.new(*tap_args(name))
      end
    end

    if ARGV.json == "v1"
      print_tap_json(taps)
    else
      print_tap_info(taps)
    end
  end

  private

  def print_tap_info(taps)
    if taps.none?
      tap_count = 0
      formula_count = 0
      command_count = 0
      pinned_count = 0
      Tap.each do |tap|
        tap_count += 1
        formula_count += tap.formula_files.size
        command_count += tap.command_files.size
        pinned_count += 1 if tap.pinned?
      end
      info = "#{tap_count} tap#{plural(tap_count)}"
      info += ", #{pinned_count} pinned"
      info += ", #{formula_count} formula#{plural(formula_count, "e")}"
      info += ", #{command_count} command#{plural(command_count)}"
      info += ", #{Tap::TAP_DIRECTORY.abv}" if Tap::TAP_DIRECTORY.directory?
      puts info
    else
      taps.each_with_index do |tap, i|
        puts unless i == 0
        info = "#{tap}: "
        if tap.installed?
          info += tap.pinned? ? "pinned, " : "unpinned, "
          formula_count = tap.formula_files.size
          info += "#{formula_count} formula#{plural(formula_count, "e")} " if formula_count > 0
          command_count = tap.command_files.size
          info += "#{command_count} command#{plural(command_count)} " if command_count > 0
          info += "\n#{tap.path} (#{tap.path.abv})"
          info += "\nFrom: #{tap.remote.nil? ? "N/A" : tap.remote}"
        else
          info += "Not installed"
        end
        puts info
      end
    end
  end

  def print_tap_json(taps)
    puts Utils::JSON.dump(taps.map(&:to_hash))
  end
end
