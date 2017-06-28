_, batt_percent, status, remaining = `pmset -g batt | tail -n +1`.match(/(\d+)%; ((?:dis)?charg(?:ed|ing)); (\d+:\d+)?/).to_a

batt_percent = batt_percent.to_i

if status == 'discharging' and remaining != nil
    output = " #{remaining} ⚡  "
else
    output = " #{batt_percent}% 🔌  "
end

if batt_percent > 40
    color = "colour010"
elsif batt_percent > 15
    color = "colour011"
else
    color = "colour009"
end


puts "##[fg=colour235,bg=#{color},bold]#{output}##[bg=default]"
