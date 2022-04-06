## -*- coding: utf-8 -*-
/*
 * Copyright (C) ${copyright_year()} The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
<%!
  def annotated_type(entry):
    if entry.enum:
       type = 'enum'
    else:
       type = entry.type
    if entry.container == 'array':
       type += '[]'

    return type

  def annotated_enum_type(entry):
    if entry.type == 'int64' and entry.container == 'array':
       type = 'long'
    else:
       type = 'int'

    return type

  def val_id_to_literal(entry, id):
    if entry.type == 'int64' and entry.container == 'array':
      return "%sL" % id
    else:
      return id
%>\

/*
 * Autogenerated from camera metadata definitions in
 * /system/media/camera/docs/metadata_definitions.xml
 * *** DO NOT EDIT BY HAND ***
 */

package android.hardware.camera.metadata;
<%
  _entry = None
  _enum_name = None
  for sec in find_all_sections(metadata):
    for entry in remove_synthetic_or_fwk_only(find_unique_entries(sec)):
      if entry.name == enum():
        _entry = entry
        _enum_name = entry.name.removeprefix("android.")
        s = _enum_name.split(".")
        s = [x[0].capitalize() + x[1:] for x in s]
        _enum_name = ''.join(s)
%>\

/**
 * ${_entry.name} enumeration values
 * @see ${_entry.name | csym}
 */
@VintfStability
@Backing(type="${annotated_enum_type(_entry)}")
enum ${_enum_name} {
  % for val in aidl_enum_values(_entry):
    % if val.id is None:
    ${aidl_enum_value_name('%s_%s'%(csym(_entry.name), val.name))},
    % else:
    ${aidl_enum_value_name('%s_%s'%(csym(_entry.name), val.name))} = ${val_id_to_literal(_entry, val.id)},
    % endif
  % endfor
}
