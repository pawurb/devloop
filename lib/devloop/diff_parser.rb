module Devloop
  class DiffParser
    def self.call(diff)
      new.call(diff)
    end

    def call(diff)
      lines = diff.split("\n")
      results = []
      lines.each_with_index do |line, index|
        if line.start_with?("+++ b/")
          file = line[6..-1]
          if lines[index + 1] && lines[index + 1].start_with?("@@ -")
            line_number = lines[index + 1].split(" ")[1].split(",")[0][1..-1]
            results << "#{file}:#{line_number}"
          end
        end
      end
      results
    end
  end
end
