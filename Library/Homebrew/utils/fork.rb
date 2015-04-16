require "fcntl"
require "socket"

module Utils
  def self.safe_fork(&block)
    socket_path = "#{Dir.mktmpdir("homebrew", HOMEBREW_TEMP)}/socket"
    server = UNIXServer.new(socket_path)
    ENV["HOMEBREW_ERROR_PIPE"] = socket_path
    read, write = IO.pipe

    pid = fork do
      begin
        server.close
        read.close
        write.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)
        yield
      rescue Exception => e
        Marshal.dump(e, write)
        write.close
        exit! 1
      end
    end

    ignore_interrupts(:quietly) do # the child will receive the interrupt and marshal it back
      begin
        socket = server.accept_nonblock
      rescue Errno::EAGAIN, Errno::EWOULDBLOCK, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
        retry unless Process.waitpid(pid, Process::WNOHANG)
      else
        socket.send_io(write)
      end
      write.close
      data = read.read
      read.close
      Process.wait(pid) unless socket.nil?
      raise Marshal.load(data) unless data.nil? or data.empty?
      raise Interrupt if $?.exitstatus == 130
      raise "Suspicious failure" unless $?.success?
    end
  ensure
    server.close
    FileUtils.rm_r File.dirname(socket_path)
  end
end
