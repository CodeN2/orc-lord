module Wordlist
  
  class Wordlist
    
    def initialize(type, min, max)
      @range_min = min
      @range_max = max
      @word = []
      @word_list = []
      @char_list, @qt_char = generate_char_list(type)
      @horizontal_pointer = @range_min - 1
      @vertical_pointer = 1
      @current_range = @range_min
      @bar = View::Bar.new(@qt_char, @range_min, @range_max)
    end

    
    def gen_wl
      
      #Clean the old file to generate the new file.
      File.open("output/out.txt", 'w') {|f|}
      
      #Start the initial value of the first wordlist line with the initial value.
      @range_min.times{|e| @word.push(@char_list.first)}

      #This loop will generate the wordlist with all possibilities with each character
      #this will run from the minimum range of character to the max size range and
      #will stop when it arrive the max range with all characters with the last character value.
      until @current_range == @range_max &&  @word.reject{|a| a == @char_list.last}.empty?
        #This will change the right value until the last value of char
        unless @word.reject{|a| a == @char_list.last}.empty?
          if @word.last != @char_list.last
            @word[@horizontal_pointer] = @char_list[@vertical_pointer]
              if @vertical_pointer + 1 <= @char_list.count - 1
                @vertical_pointer += 1
              else
                @vertical_pointer = 0
              end
            write_on_file(@word)
            @bar.update_bar
          #If it don't arrive the last value of character at the last element off array in line,
          #this will jump one to left and verify if it's the last character:
          #1. if it's not the last character, he will incremente to the next character in this
          #position and set the first character to all characters to your right;
          #2. but if it's not the last value, he will going to recursive method and check one left position in array.
          else
            @word = carry(@word, @horizontal_pointer -1, @char_list)
            write_on_file(@word)
            @bar.update_bar
          end
        else
          @current_range += 1
          @horizontal_pointer += 1
          @current_range.times{|e| @word[e] = @char_list.first}
        end
      end
      puts 'Wordlist created! You can see the file in ~/output/wordlist.txt'
    end

    
    def write_on_file(word)
      word = word.join
      
      File.open("output/out.txt", 'a') { |f|
        f.puts(word)
      }
    end

    
    def carry(arr, hor_pointer, char_list)
      if arr[hor_pointer] != char_list.last
        arr[hor_pointer] = char_list[char_list.index(arr[hor_pointer]) + 1]
        for i in  ( Array (hor_pointer + 1)..(arr.count - 1) )
          arr[i] = char_list.first
        end
        return arr
      else
        return carry(arr, hor_pointer -1, char_list)
      end
    end


    def generate_char_list(type_char_list)
      alpha_lower = Array 'a'..'z'
      alpha_upper = Array 'A'..'Z'
      numeric = Array '0'..'9'
      special_character = ['\'', '\"', '!', '@', '#', '$', '%', '&', '*',\
          '(', ')', '-', '_', '+', '=', ',', '.', ';', ':', '?', '/',\
          '{', '}', '[', ']', '\\', '|', '¬', '¹', '²', '³', '£', '¢',\
          '´', '`', '§', 'ª', 'º', '°', '\^', '~']
      char_list = []
      
      if type_char_list.include? :alpha_low
        char_list += alpha_lower
      end

      if type_char_list.include? :alpha_up
        char_list += alpha_upper
      end

      if type_char_list.include? :numeric
        char_list += numeric
      end

      if type_char_list.include? :special
        char_list += special_character
      end

      return char_list, char_list.count
    end
    
    
  end

end