def remove_duplicates(input_string):
    result = ""

    for char in input_string:
        if char not in result:
            result += char

    return result


# Test cases
print(remove_duplicates("programming"))  # progamin
print(remove_duplicates("hello"))        # helo