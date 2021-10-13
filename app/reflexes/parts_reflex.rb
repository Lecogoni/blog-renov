class PartsReflex < ApplicationReflex

    def sort
        puts '-----------------------------INSIDE -------------------'
        puts '--------------------------------------------------------'
        puts '--------------------------------------------------------'

        parts = JSON.parse(element.dataset[:parts])

        parts.each do |part|
            part_record = Part.find(part['id'])
            part_record.update(position: part['position'])
        end
    end

end
