Process.daemon(true, false) if ARGV.any? {|i| i == '-D' }

@pid_file = File.expand_path('../daemon.pid', __FILE__)
p @pid_file
open(@pid_file, 'w') {|f| f << Process.pid} if @pid_file

loop do
  puts "i"
  sleep 60
end
