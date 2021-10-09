// Function to parse design file and set appropriate channels
def parse_design(LinkedHashMap row) {
    def meta = [:]
    meta.name         = row.sample
    meta.group        = row.group
    meta.single_end   = !row.read_2

    def array = []
    if (meta.single_end) {
        array = [ meta, [ file(row.read_1, checkIfExists: true) ] ]
    } else {
        array = [ meta, [ file(row.read_1, checkIfExists: true), file(row.read_2, checkIfExists: true) ] ]
    }
    return array
}
// Create a channel for the design file
design = Channel.fromPath(params.design, checkIfExists:true)

// Split CSV file into columns, create channels of reads files
design
    .splitCsv( header: true )
    .map { parse_design(it) }
    .set { reads }
