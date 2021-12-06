"""
csv_to_dataframe(csv_path::String,file_regexp::String)::DataFrame

Convert CSV files to a DataFrame.

# Arguments
- `csv_path::String`: path of csv files 
- `file_regexp::String`: regular expression of csv files to convert DataFrame

# Example

    csv_to_dataframe("../data/csv/monthly/"; file_regexp=r"(.*)")

"""
function csv_to_dataframe(csv_path::String;
                        file_regexp::Regex=r"(.*)",delim::String=",",
                        header::Bool=false)::DataFrame
    # get all list of directory
    lst_dir = readdir(abspath(csv_path),join=true)
    # select file only
    lst_files = lst_dir[isfile.(lst_dir)]
    df = DataFrame()
    for f in lst_files
        m = match(file_regexp,f)
        append!(df,DataFrame(CSV.File(m.match;header=header,delim=delim)))
    end
    return df
end