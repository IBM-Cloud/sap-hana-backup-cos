#!/usr/bin/python

import re

class VersOperations(object):

    def __init__(self, name):
        self.name = name

    def _get_version_parts(v):
        # python3-jinja2-2.10.1-2.el8_0.noarch
        v_parts = v.split('-')
        v_part1 = ''
        v_part2 = ''
        parts = []
        for element in v_parts:
            letters = re.match(r'^[a-zA-Z]+', element)
            if letters:
                continue
            vers_part = re.match(r'^[0-9]+.*', element)
            if vers_part:
                vers_part_maj = re.match(r'^[0-9]+\.[0-9]+.*', element)
                if vers_part_maj:
                    # 2.10.1
                    v_part1 = vers_part_maj.group(0)
                    parts.append(v_part1)
                else:
                    # 2.el8_0.noarch
                    v_part2 = vers_part.group(0).split('.')[0]
                    parts.append(v_part2)
        return parts

    def _get_numberoffigures(v_part):
        # v_part = '2.10.1'
        # v_part = '2'
        v_groups = v_part.split('.')
        group_length = []
        for element in v_groups:
            group_length.append(len(element))
        # group_length = [1, 2, 1]
        # group_length = [1]
        return group_length
    
    def _max_group_lenght(gr_lenght1, gr_lenght2):
        max_list_len = gr_lenght1
        # Suppose the fist list has more elements than the second
        # gr_lenght1 = [1, 2, 1, 3]
        # gr_lenght1 = [1, 1, 2]
        min_list_len = gr_lenght2
        max_gr_length = []
        if len(gr_lenght1) <= len(gr_lenght2):
            max_list_len = gr_lenght2
            min_list_len = gr_lenght1
        for i in range(len(min_list_len)):
                if min_list_len[i] >= max_list_len[i]:
                    max_gr_length.append(min_list_len[i])
                else:
                    max_gr_length.append(max_list_len[i])
        # max_group_length = [1, 2, 2]
        return max_gr_length

    def _create_comp_string(v_parts, max_gr_lengthp1, max_gr_lengthp2):
        # v_parts = ['2.10.1', '2']
        # max_gr_lengthp1 = [1, 2, 2]
        # max_gr_lengthp2 = [1]
        v_groups = v_parts[0].split('.')
        final_vers_string = ''
        for i in range(len(v_groups)):
            new_str = ''
            if len(v_groups[i]) < max_gr_lengthp1[i]:
                number_of_zeros = max_gr_lengthp1[i] - len(v_groups[i])
                zero_to_append = ''
                for j in range(number_of_zeros):
                    zero_to_append += '0'
                new_str = zero_to_append + v_groups[i] 
            else:
                new_str = v_groups[i]
            final_vers_string += new_str
        if max_gr_lengthp2:
            if len(v_parts[1]) < max_gr_lengthp2[0]:
                number_of_zeros = max_gr_lengthp2[0] - len(v_parts[1])
                zero_to_append = ''
                for j in range(number_of_zeros):
                    zero_to_append += '0'
                final_vers_string += zero_to_append + v_parts[1]
            else:
                final_vers_string += v_parts[1]
        return final_vers_string

class FilterModule(object):
    '''Compare package versions'''

    def filters(self):
        return {
            'compare_versions': self.compare_versions
        }

    def compare_versions(self, versions_list):
        pkg_version1 = versions_list[0]
        comparator = versions_list[1]
        pkg_version2 = versions_list[2]
        vers_parts_pkg1 = VersOperations._get_version_parts(pkg_version1)
        vers_parts_pkg2 = VersOperations._get_version_parts(pkg_version2)
        no_figures_part1_pkg1 = VersOperations._get_numberoffigures(vers_parts_pkg1[0])
        if len(vers_parts_pkg1) > 1:
            no_figures_part2_pkg1 = VersOperations._get_numberoffigures(vers_parts_pkg1[1])
        no_figures_part1_pkg2 = VersOperations._get_numberoffigures(vers_parts_pkg2[0])
        if len(vers_parts_pkg2) > 1:
            no_figures_part2_pkg2 = VersOperations._get_numberoffigures(vers_parts_pkg2[1])
        max_group_lenght_part1 = VersOperations._max_group_lenght(no_figures_part1_pkg1, no_figures_part1_pkg2)
        max_group_lenght_part2 = None
        if len(vers_parts_pkg1) > 1 and len(vers_parts_pkg2) > 1:
            max_group_lenght_part2 = VersOperations._max_group_lenght(no_figures_part2_pkg1, no_figures_part2_pkg2)
        vers_string_pkg1 = VersOperations._create_comp_string(vers_parts_pkg1, max_group_lenght_part1, max_group_lenght_part2)
        vers_string_pkg2 = VersOperations._create_comp_string(vers_parts_pkg2, max_group_lenght_part1, max_group_lenght_part2)
        if comparator == 'eq':
            if int(vers_string_pkg1) == int(vers_string_pkg2):
                return True
            else:
                return False
        elif comparator == 'ge':
            if int(vers_string_pkg1) >= int(vers_string_pkg2):
                return True
            else:
                return False
        elif comparator == 'gt':
            if int(vers_string_pkg1) > int(vers_string_pkg2):
                return True
            else:
                return False
        elif comparator == 'le':
            if int(vers_string_pkg1) <= int(vers_string_pkg2):
                return True
            else:
                return False
        elif comparator == 'lt':
            if int(vers_string_pkg1) < int(vers_string_pkg2):
                return True
            else:
                return False