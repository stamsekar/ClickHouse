-- Tags: no-fasttest, no-parallel

insert into function file(03241_data_without_dict.orc) 
select toLowCardinality(cast(if (number % 10 = 0, null, number % 10) as Nullable(String))) as c from numbers(100000)
settings output_format_orc_dictionary_key_size_threshold = 0, engine_file_truncate_on_insert = 1;

insert into function file(03241_data_with_dict.orc) 
select toLowCardinality(cast(if (number % 10 = 0, null, number % 10) as Nullable(String))) as c from numbers(100000)
settings output_format_orc_dictionary_key_size_threshold = 0.1, engine_file_truncate_on_insert = 1;


set input_format_orc_dictionary_as_low_cardinality = 1;

desc file(03241_data_without_dict.orc);
desc file(03241_data_with_dict.orc);

select c, count(1) from file(03241_data_without_dict.orc) group by c order by c;
select c, count(1) from file(03241_data_with_dict.orc) group by c order by c;

select c, count(1) from file(03241_data_without_dict.orc, ORC, 'c String') group by c order by c;
select c, count(1) from file(03241_data_with_dict.orc, ORC, 'c LowCardinality(String)') group by c order by c;


set input_format_orc_dictionary_as_low_cardinality = 0;

desc file(03241_data_without_dict.orc);
desc file(03241_data_with_dict.orc);

select c, count(1) from file(03241_data_without_dict.orc) group by c order by c;
select c, count(1) from file(03241_data_with_dict.orc) group by c order by c;

select c, count(1) from file(03241_data_without_dict.orc, ORC, 'c String') group by c order by c;
select c, count(1) from file(03241_data_with_dict.orc, ORC, 'c LowCardinality(String)') group by c order by c;
