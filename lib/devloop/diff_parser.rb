module Devloop
  class DiffParser
    def self.call(diff)
      new.call(diff)
    end

    Diff = Struct.new(:filename, :line_number)

    def call(diff)
      _, diffs_data = diff.split("\n").reduce(["", []]) do |(file, diffs_data), line|
        if line.start_with?("+++ b/")
          [line[6..-1], diffs_data]
        elsif line.start_with?("@@ -")
          line_number = line.match(/@@ -(\d+)/)[1]
          [file, diffs_data << Diff.new(relative_path(file), line_number)]
        else
          [file, diffs_data]
        end
      end.uniq

      results = diffs_data.group_by do |el|
        el.filename
      end.map do |key, value|
        line_numbers = value.map(&:line_number).map(&:to_i)
        if line_numbers.include?(0) || line_numbers.include?(1)
          key
        else
          lines_range = (line_numbers.min..line_numbers.max).to_a.join(":")

          "#{key}:#{lines_range}"
        end
      end

      # Remove filenames with line number if filename without line number is present
      res = results.reject { |result| results.include?(result.split(":").first) && result.include?(":") }
    end

    private

    def relative_path(path)
      path.gsub(project_path, "")
    end

    def project_path
      @project_path ||= Dir.pwd.gsub("#{git_root_path}/", "") + "/"
    end

    def git_root_path
      @git_root_path ||= `git rev-parse --show-toplevel`.strip
    end
  end
end
