module Emailer
  module StringUtilities
    
    def q_encode_char(n)
      hex = n.to_s 16
      hex = "0#{hex}" if hex.length == 1
      "=#{hex}"
    end
    
    def q_char(n)
      # We can escape SPACE (0x20) with '_'
      return '_' if n == 32
      
      # We can use ASCII 33 to 126, except '=', '?' and '_' (see above).
      # All other byte values will be encoded with =XX
      (n < 33 || n == 61 || n == 63 || n == 95 || n > 126) ? q_encode_char(n) : n.chr
    end
    
    def q_encode_bytes(str)
      str.bytes.map { |b| q_char(b) }
    end
    
    def q_word(encoding, encoded_str)
      "=?#{encoding}?Q?#{encoded_str}?="
    end
    
    def string_to_q(str)
      max_word_length = 76 - "=?#{str.encoding.to_s}?Q??=".length
      lines = split_string q_encode_bytes(str), max_word_length
      lines.map { |l| q_word(str.encoding.to_s, l) }.join("\r\n ")
    end
    
    def split_string(parts, maxlen)
      result = ['']
      while parts.length > 0
        if (result[-1].length + parts[0].length <= maxlen)
          result[-1] += parts.shift
        else
          result << parts.shift
        end
      end
      
      result
    end
    
  end
end

# require 'lib/emailer/string_utilities'
# extend Emailer::StringUtilities
