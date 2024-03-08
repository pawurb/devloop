module Devloop
  class DiffParser
    def self.call(diff)
      new.call(diff)
    end

    def call(diff)
      _, results = diff.split("\n").reduce(["", []]) do |(file, results), line|
        if line.start_with?("+++ b/")
          [line[6..-1], results]
        elsif line.start_with?("@@ -")
          line_number = line.match(/@@ -(\d+)/)[1]
          [file, results << "#{file}:#{line_number}"]
        else
          [file, results]
        end
      end
      results
    end
  end
end
