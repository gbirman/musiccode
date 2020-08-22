
# this script will convert all docx to readme using pandoc
# it will also remove unnecessary doc, tmp, and rec.ck (for recording) files

for dir in */ 
do

    cd ${dir}
    echo "Entering ${dir}"

    docx=(`find . -maxdepth 1 -name "*.docx"`)
    doc=(`find . -maxdepth 1 -name "*.doc"`)
    tmp=(`find . -maxdepth 1 -name "*~*"`)
    rec=(`find . -maxdepth 1 -name "rec.ck"`)

    # convert docx to readme
    if [ ${#docx[@]} -gt 0   ]; then
        echo "Converting ${docx##*/} to README"
        pandoc ${docx} -t gfm -o README.md 
    fi

    # remove .doc files
    if [ ${#doc[@]} -gt 0   ]; then
        echo "Removing ${doc##*/}"
        rm *.doc
    fi

    # remove temp files
    if [ ${#tmp[@]} -gt 0   ]; then
        rm *~*
    fi

    # remove rec.ck files
    if [ ${#rec[@]} -gt 0   ]; then
        echo "Removing ${doc##*/}"
        rm rec.ck
    fi

    cd ..
done