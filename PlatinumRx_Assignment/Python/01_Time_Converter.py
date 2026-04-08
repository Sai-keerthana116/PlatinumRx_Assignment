def convert_minutes(minutes):
    hours = minutes // 60
    remaining_minutes = minutes % 60

    if hours == 1:
        hour_text = "1 hr"
    else:
        hour_text = f"{hours} hrs"

    return f"{hour_text} {remaining_minutes} minutes"


# Test cases
print(convert_minutes(130))  # 2 hrs 10 minutes
print(convert_minutes(110))  # 1 hr 50 minutes