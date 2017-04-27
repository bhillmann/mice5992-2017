### rarefy (could normalize instead?)
rm otutable-subset-n50000-s10-norm.biom
# biom normalize-table -i otutable-subset-n50000-s10.biom -o otutable-subset-n50000-s10-norm.biom -r
#
cp otutable-subset-n50000-s10.biom otutable-subset-n50000-s10-norm.biom
#
## various subsets and collapsings
echo "filtering"
#
### No soylent
filter_samples_from_otu_table.py -m map-subset.txt -s 'UserName:*,!Subject_17,!Subject_38' --output_mapping_fp map-subset-no-soylent.txt -i otutable-subset-n50000-s10-norm.biom -o otutable-subset-n50000-s10-norm-no-soylent.biom
#
### No transition
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -m map-subset-no-soylent.txt --output_mapping_fp map-subset-no-soylent-no-transition.txt -s 'StudyDayNo:*,!Day.09,!Day.10,!Day.11'
#
### pre/post
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre.txt -s "Treatment:Pre"
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-post.txt -s "Treatment:Post"
#
#echo "collapsing"
#
## collapse by Subject, including soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp otutable-subset-n50000-s10-norm-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset.txt UserName map-subset-collapse-UserName.txt
#
## collapse by Subject, excluding soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset-no-soylent.txt UserName map-subset-no-soylent-collapse-UserName.txt
#
## collapse by Subject, pre/post, excluding soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition-pre.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition-post.txt --output_mapping_fp map-subset-no-soylent-no-transition-post-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-no-transition-post-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset-no-soylent-no-transition-pre.txt UserName map-subset-no-soylent-no-transition-pre-collapse-UserName.txt
Rscript collapse_map.r map-subset-no-soylent-no-transition-post.txt UserName map-subset-no-soylent-no-transition-post-collapse-UserName.txt
#
# summarize taxa for all tables
for f in otutable-subset-n50000-s10-norm*.biom; do echo ; summarize_taxa.py -i $f -o taxa -L 5,6,7,8 -a True; done
for file in *.biom; do biom convert -i "$file" -o "$(basename "$file" .biom)".txt --to-tsv; done
