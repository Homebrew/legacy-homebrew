module MachO
  # Opens the given filename as a MachOFile or FatFile, depending on its magic.
  # @param filename [String] the file being opened
  # @return [MachO::MachOFile] if the file is a Mach-O
  # @return [MachO::FatFile] if the file is a Fat file
  def self.open(filename)
    # open file and test magic instead of using exceptions for control?
    begin
      file = MachOFile.new(filename)
    rescue FatBinaryError
      file = FatFile.new(filename)
    end

    file
  end
end