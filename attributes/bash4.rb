default['lyraphase_workstation']['bash'] = {}
default['lyraphase_workstation']['bash']['set_login_shell'] = true
default['lyraphase_workstation']['bash']['etc_shells_path'] = '/etc/shells'
default['lyraphase_workstation']['bash']['etc_shells'] =
                                            [
                                              '/usr/local/bin/bash',
                                              '/bin/bash',
                                              '/bin/csh',
                                              '/bin/ksh',
                                              '/bin/sh',
                                              '/bin/tcsh',
                                              '/bin/zsh'
                                            ]
