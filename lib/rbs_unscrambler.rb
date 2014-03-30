require 'rbs_unscrambler/version'
require 'crypt/blowfish'

class RbsUnscrambler
  RBS_HEADER = 'RBS1.0'
  BLOCK_SIZE = 8

  def initialize(filename, password)
    @blowfish = Crypt::Blowfish.new(password)
    @unscrambled_rbs = ''

    File.open(filename, 'rb') do |file|
      read_header( file )
      @unscrambled_rbs += read_encrypted_record( file ) until file.eof?
    end
  end

  def unscramble
    @unscrambled_rbs
  end

  def read_header(file)
    header = file.read(6)
    fail "Not an .rbs file!" unless header == RBS_HEADER
  end

  def read_encrypted_record(file)
    record_size = file.read(4).unpack('L')[0]
    
    fail "Invalid block size" unless record_size%BLOCK_SIZE==0

    num_of_blocks = record_size/BLOCK_SIZE

    encrypted_record = num_of_blocks.times.collect do |index|
      #if the last block, remove padding
      remove_padding = index==(num_of_blocks-1)
      read_encrypted_block(file, remove_padding)
    end

    encrypted_record.join
  end

  def read_encrypted_block(file, remove_padding)
    block = file.read( BLOCK_SIZE )

    #SU is using Blowfish-compat so I need to use big endians
    block_big_endian = block.unpack('N*').pack('V*')

    decrypted_big_endian = @blowfish.decrypt_block( block_big_endian )

    #decrypted, I can now switch to small endian
    decrypted = decrypted_big_endian.unpack('N*').pack('V*')

    decrypted.gsub!(/\x00*$/,'') if remove_padding

    decrypted
  end

end