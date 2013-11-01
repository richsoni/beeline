require "beeline/version"
require 'digest/md5'

module Beeline
  file_prefix = 'tmp/cache/routes_'

  md5 = Digest::MD5::new
  unless File.exist?('config/routes.rb')
    puts "Must be used in a Rails project"
    exit 0
  end

  puts "... Creating checksums"
  new_checksum = md5.update(File.binread('config/routes.rb'))
  old_file     = Dir.glob("#{file_prefix}*").first
  old_checksum = (old_file || '').sub(file_prefix, '')

  puts "Old Checksum is:#{old_checksum}"
  puts "New Checksum is:#{new_checksum}"

  unless new_checksum == old_checksum
    File.delete(old_file) if old_file
    puts 'bundle exec rake routes'
    routes = `bundle exec rake routes`
    File.open("#{file_prefix}#{new_checksum}", 'w') { |file| file.write(routes) } 
  else
    puts " => Routes Have Not Changed "
  end
  puts '************************'
end
