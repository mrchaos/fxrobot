"""
arrow_read(file::String)::DataFrame

Read contents from a arrow file into a DataFrame

# Arguments
- `file::String`: path to the input file (arrow file)

# Example

    df = arrow_read("data.arrow")

"""
function arrow_read(file::String)::DataFrame
    DataFrame(Arrow.Table(file))
end


"""
    arrow_write(df::DataFrame,file::String)::Nothing

Write DataFrame to a arrow file.

# Arguments
- `df::DataFrame`: DataFrame 
- `file::String`: filepath to which object shall be written

# Example

    arrow_write(df, "data.arrow")

"""
function arrow_write(df::DataFrame,file::String)::String
    if isfile(file)
        rm(file)        
    end
    return Arrow.write(file,df)
end