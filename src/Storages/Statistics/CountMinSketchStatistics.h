#pragma once

#if USE_DATASKETCHES

#include <Storages/Statistics/Statistics.h>
#include <count_min.hpp>
#include <Common/Allocator.h>

namespace DB
{

/// CountMinSketchStatistics is used to estimate expression like col = 'value' or col in ('v1', 'v2').
class CountMinSketchStatistics : public IStatistics
{
public:
    explicit CountMinSketchStatistics(const SingleStatisticsDescription & stat_, DataTypePtr data_type_);

    Float64 estimateEqual(const Field & value) const;

    void serialize(WriteBuffer & buf) override;

    void deserialize(ReadBuffer & buf) override;

    void update(const ColumnPtr & column) override;

private:
    static constexpr size_t HASH_COUNT = 8;
    static constexpr size_t BUCKET_COUNT = 2048;

    datasketches::count_min_sketch<Float64> data;
    DataTypePtr data_type;
};

StatisticsPtr CountMinSketchCreator(const SingleStatisticsDescription & stat, DataTypePtr);
void CountMinSketchValidator(const SingleStatisticsDescription &, DataTypePtr data_type);

}

#endif
