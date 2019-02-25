use strict; # applies to all packages defined in the file

package SubSystem::TaggedFiles::CachedDB;
use 5.006;
use warnings;
use Module::Runtime qw/require_module/;
use base qw/
  SubSystem::TaggedFiles
  SubSystem::CachedDB::DBI
  /;

=head1 NAME
	SubSystem::TaggedFiles::CachedDB - use cachedDB to do things
=head1 VERSION
	Version 0.01
=cut

our $VERSION = '0.01';

=head1 SYNOPSIS
	^
=head1 EXPORT
	None
=head1 SUBROUTINES/METHODS
=head2 Critical Path
=cut

sub _init {
	my ( $self, $conf ) = @_;
	my $cdb_init = SubSystem::CachedDB::DBI::_init( $self, \%{$conf->{shared_config} || {}}, );
	for my $external_module ( qw/ TagForSubject IdForPath/ ) {

		if ( $conf->{$external_module} ) {
			$self->$external_module( $conf->{$external_module} );
		} else {
			my $full_module_name = "SubSystem::$external_module\::CachedDB";
			require_module( $full_module_name );

			$self->$external_module( "$full_module_name"->new( {%{$conf->{shared_config} || {}}, %{$conf->{lc( $external_module ) . '_conf'} || {}},} ) );
		}
	}
	return {pass => 1};
}

=head2 Private Functions
=head3 _file_instance_without_subject
	Get a file without a corresponding subject_files entry
=cut

sub _file_instance_without_subject {
	my ( $self, $p ) = @_;

	#how to do this in DynamoDB?
	my $sth;
	unless ( $sth = $self->_preserve_sth( "file_instance_without_subject()" ) ) {
		$sth = $self->_preserve_sth(
			"file_instance_without_subject()",
			sprintf( '
			select f.id from %s as f
			left outer join %s as stf
				on f.id = stf.file_id
			where stf.id is null 
			limit ?
			', 'files', 'subject_files' )
		);
	}

	$sth->execute( $p->{limit} || 1 );

	my $rows = $sth->fetchall_arrayref( [0] );

	if ( @{$rows} ) {
		my $return;
		for my $row ( @{$rows} ) {
			push( @{$return}, $row->[0] );
		}
		return {pass => $return}; # return!
	} else {
		return {fail => "No applicable files", no_files => 1};
	}

}

=head1 AUTHOR

mmacnair, C<< <mmacnair at cpan.org> >>

=head1 BUGS

	TODO Bugs

=head1 SUPPORT

	TODO Support

=head1 ACKNOWLEDGEMENTS
	TODO 

=head1 LICENSE AND COPYRIGHT

Copyright 2018 mmacnair.

This program is distributed under the (Revised) BSD License:
L<http://www.opensource.org/licenses/BSD-3-Clause>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of mmacnair's Organization
nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior written
permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;
