function create_output_dir

create('Output');

set_list={'Checkerboard','L Checkerboard','L2 Checkerboard','Sonic','Light Sonic'};
coord_list={'MV','H','G'};


for set_ind=1:length(set_list)
    set=set_list{set_ind};
    create(['Output/',set]);
    for coord_ind=1:length(coord_list)
        coord_type=coord_list{coord_ind};
        create(['Output/',set,'/',coord_type]);
    end
end

end


function create(dir)
if ~exist(dir,'dir')
    mkdir(dir);
end
end