#include <fastcdr/Cdr.h>
#include <fastcdr/FastBuffer.h>
#include <fastcdr/exceptions/NotEnoughMemoryException.h>

#include <cstdint>
#include <string>
#include <vector>

int main() {
    char storage[256]{};
    eprosima::fastcdr::FastBuffer buffer(storage, sizeof(storage));
    eprosima::fastcdr::Cdr writer(buffer);
    const std::vector<std::uint32_t> expected{1, 42, 65536};
    writer << std::int32_t{123} << std::string{"Fast CDR"} << expected;

    eprosima::fastcdr::FastBuffer input(storage, writer.get_serialized_data_length());
    eprosima::fastcdr::Cdr reader(input);
    std::int32_t number;
    std::string text;
    std::vector<std::uint32_t> values;
    reader >> number >> text >> values;
    if (number != 123 || text != "Fast CDR" || values != expected) {
        return 1;
    }

    eprosima::fastcdr::FastBuffer truncated(storage, 1);
    eprosima::fastcdr::Cdr invalid(truncated);
    try {
        std::uint64_t value;
        invalid >> value;
        return 2;
    } catch (const eprosima::fastcdr::exception::NotEnoughMemoryException&) {
        return 0;
    }
}
