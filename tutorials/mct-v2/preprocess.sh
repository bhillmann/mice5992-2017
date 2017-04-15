# rarefy (could normalize instead?)
rm otutable-subset-n50000-s10-norm.biom
biom normalize-table -i otutable-subset-n50000-s10.biom -o otutable-subset-n50000-s10-norm.biom -r

# various subsets and collapsings
echo "filtering"
filter_samples_from_otu_table.py --sample_id_fp map-subset.txt -i nutrients-norm.biom -o nutrients-norm-subset.biom

## No soylent
filter_samples_from_otu_table.py -m map-subset.txt -s 'UserName:*,!Subject_17,!Subject_38' --output_mapping_fp map-subset-no-soylent.txt -i foodtable_for_phylogenetics-subset.biom -o foodtable_for_phylogenetics-subset-no-soylent.biom
filter_samples_from_otu_table.py -m map-subset.txt -s 'UserName:*,!Subject_17,!Subject_38' --output_mapping_fp map-subset-no-soylent.txt -i foodtable_for_phylogenetics-subset.biom -o foodtable_for_taxonomy-subset-no-soylent.biom
filter_samples_from_otu_table.py -m map-subset.txt -s 'UserName:*,!Subject_17,!Subject_38' --output_mapping_fp map-subset-no-soylent.txt -i otutable-subset-n50000-s10-norm.biom -o otutable-subset-n50000-s10-norm-no-soylent.biom
filter_samples_from_otu_table.py -m map-subset.txt -s 'UserName:*,!Subject_17,!Subject_38' -i nutrients-norm-subset.biom -o nutrients-norm-subset-no-soylent.biom 

## No transition
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -m map-subset-no-soylent.txt --output_mapping_fp map-subset-no-soylent-no-transition.txt -s 'StudyDayNo:*,!Day.09,!Day.10,!Day.11'
filter_samples_from_otu_table.py -i foodtable_for_phylogenetics-subset-no-soylent.biom -o foodtable_for_phylogenetics-subset-no-soylent-no-transition.biom -m map-subset-no-soylent.txt --output_mapping_fp map-subset-no-soylent-no-transition.txt -s 'StudyDayNo:*,!Day.09,!Day.10,!Day.11'
filter_samples_from_otu_table.py -i foodtable_for_taxonomy-subset-no-soylent.biom -o foodtable_for_taxonomy-subset-no-soylent-no-transition.biom -m map-subset-no-soylent.txt --output_mapping_fp map-subset-no-soylent-no-transition.txt -s 'StudyDayNo:*,!Day.09,!Day.10,!Day.11'
filter_samples_from_otu_table.py -i nutrients-norm-subset-no-soylent.biom -o nutrients-norm-subset-no-soylent-no-transition.biom -m map-subset-no-soylent.txt -s 'StudyDayNo:*,!Day.09,!Day.10,!Day.11'

## pre/post
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre.txt -s "Treatment:Pre"
filter_samples_from_otu_table.py -i otutable-subset-n50000-s10-norm-no-soylent-no-transition.biom -o otutable-subset-n50000-s10-norm-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-post.txt -s "Treatment:Post"
filter_samples_from_otu_table.py -i foodtable_for_phylogenetics-subset-no-soylent-no-transition.biom  -o foodtable_for_phylogenetics-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre.txt -s "Treatment:Pre"
filter_samples_from_otu_table.py -i foodtable_for_phylogenetics-subset-no-soylent-no-transition.biom  -o foodtable_for_phylogenetics-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-post.txt -s "Treatment:Post"
filter_samples_from_otu_table.py -i foodtable_for_taxonomy-subset-no-soylent-no-transition.biom  -o foodtable_for_taxonomy-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre.txt -s "Treatment:Pre"
filter_samples_from_otu_table.py -i foodtable_for_taxonomy-subset-no-soylent-no-transition.biom  -o foodtable_for_taxonomy-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition.txt --output_mapping_fp map-subset-no-soylent-no-transition-post.txt -s "Treatment:Post"
filter_samples_from_otu_table.py -i nutrients-norm-subset-no-soylent-no-transition.biom  -o nutrients-norm-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition.txt  -s "Treatment:Pre"
filter_samples_from_otu_table.py -i nutrients-norm-subset-no-soylent-no-transition.biom  -o nutrients-norm-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition.txt -s "Treatment:Post"

echo "collapsing"

# collapse by Subject, including soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp otutable-subset-n50000-s10-norm-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_phylogenetics-subset.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp foodtable_for_phylogenetics-subset-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_taxonomy-subset.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp foodtable_for_taxonomy-subset-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b nutrients-norm-subset.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp nutrients-norm-subset-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset.txt UserName map-subset-collapse-UserName.txt

# collapse by Subject, excluding soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_phylogenetics-subset-no-soylent.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp foodtable_for_phylogenetics-subset-no-soylent-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_taxonomy-subset-no-soylent.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp foodtable_for_taxonomy-subset-no-soylent-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b nutrients-norm-subset-no-soylent.biom -m map-subset.txt --output_mapping_fp tmp.txt --output_biom_fp nutrients-norm-subset-no-soylent-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset-no-soylent.txt UserName map-subset-no-soylent-collapse-UserName.txt

# collapse by Subject, pre/post, excluding soylent
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition-pre.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-no-transition-pre-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b otutable-subset-n50000-s10-norm-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition-post.txt --output_mapping_fp map-subset-no-soylent-no-transition-post-collapse-UserName.txt --output_biom_fp otutable-subset-n50000-s10-norm-no-soylent-no-transition-post-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_phylogenetics-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition-pre.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre-collapse-UserName.txt --output_biom_fp foodtable_for_phylogenetics-subset-no-soylent-no-transition-pre-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_phylogenetics-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition-post.txt --output_mapping_fp map-subset-no-soylent-no-transition-post-collapse-UserName.txt --output_biom_fp foodtable_for_phylogenetics-subset-no-soylent-no-transition-post-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_taxonomy-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition-pre.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre-collapse-UserName.txt --output_biom_fp foodtable_for_taxonomy-subset-no-soylent-no-transition-pre-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b foodtable_for_taxonomy-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition-post.txt --output_mapping_fp map-subset-no-soylent-no-transition-post-collapse-UserName.txt --output_biom_fp foodtable_for_taxonomy-subset-no-soylent-no-transition-post-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b nutrients-norm-subset-no-soylent-no-transition-pre.biom -m map-subset-no-soylent-no-transition-pre.txt --output_mapping_fp map-subset-no-soylent-no-transition-pre-collapse-UserName.txt --output_biom_fp nutrients-norm-subset-no-soylent-no-transition-pre-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
collapse_samples.py -b nutrients-norm-subset-no-soylent-no-transition-post.biom -m map-subset-no-soylent-no-transition-post.txt --output_mapping_fp map-subset-no-soylent-no-transition-post-collapse-UserName.txt --output_biom_fp nutrients-norm-subset-no-soylent-no-transition-post-collapse-UserName.biom --collapse_mode mean --collapse_fields UserName
Rscript collapse_map.r map-subset-no-soylent-no-transition-pre.txt UserName map-subset-no-soylent-no-transition-pre-collapse-UserName.txt
Rscript collapse_map.r map-subset-no-soylent-no-transition-post.txt UserName map-subset-no-soylent-no-transition-post-collapse-UserName.txt

# summarize taxa for all tables
for f in otutable-subset-n50000-s10-norm*.biom; do echo ; summarize_taxa.py -i $f -o taxa; done

for f in foodtable_for_taxonomy-subset*.biom; do echo $f; summarize_taxa.py -i $f -o foodtaxa; done

