# == Define: kdump::params::checkdracutargs
#
define kdump::params::checkdracutargs {
    if $name =~ /--mount / {
      if $kdump::nfs != undef {
        fail('Parameter nfs should not be set when dracut argument --mount is used.')
      }
    }
  }

