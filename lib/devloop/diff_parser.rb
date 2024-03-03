module Devloop
  class DiffParser
    def self.call(diff)
      new.call(diff)
    end

    def call(diff)
      lines = diff.split("\n")
      results = []
      file = ""
      lines.each_with_index do |line, index|
        if line.start_with?("+++ b/")
          file = line[6..-1]
        elsif line.start_with?("@@ -")
          line_number = line.match(/@@ -(\d+)/)[1]
          results << "#{file}:#{line_number}"
        end
      end
      results
    end
  end
end
