#Rikulo Commons


[Rikulo Commons](http://rikulo.org) is a collection of common reusable Dart classes and utilities.

* [Home](http://rikulo.org)
* [Documentation](http://docs.rikulo.org)
* [API Reference](http://api.rikulo.org/commons/latest)
* [Discussion](http://stackoverflow.com/questions/tagged/rikulo)
* [Issues](https://github.com/rikulo/commons/issues)

Rikulo Commons is distributed under an Apache 2.0 License.

[![Build Status](https://drone.io/github.com/rikulo/commons/status.png)](https://drone.io/github.com/rikulo/commons/latest)

##Install from Dart Pub Repository

Add this to your `pubspec.yaml` (or create it):

    dependencies:
      rikulo_commmons:

Then run the [Pub Package Manager](http://pub.dartlang.org/doc) (comes with the Dart SDK):

    pub install

##Install from Github for Bleeding Edge Stuff

To install stuff that is still in development, add this to your `pubspec.yam`:

    dependencies:
      rikulo_commmons:
        git: git://github.com/rikulo/commons.git

For more information, please refer to [Pub: Dependencies](http://pub.dartlang.org/doc/pubspec.html#dependencies).

##Run on Client and/or Server

<table border="1" width="100%">
  <tr>
    <td>Library</td>
    <td>Run on Server</td>
    <td>Run on Client</td>
  </tr>
  <tr>
    <td><code>async.dart</code></td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td><code>io.dart</code></td>
    <td>Yes</td>
    <td>No</td>
  </tr>
  <tr>
    <td><code>js.dart</code></td>
    <td>No</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td><code>mirrors.dart</code></td>
    <td>Yes</td>
    <td>Yes</td>
  </tr>
  <tr>
    <td><code>util.dart</code></td>
    <td>Yes</td>
    <td>Yes</td>
  </tr>
</table>

##Notes to Contributors

###Fork Rikulo Commons

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

Please be aware that one of Rikulo's design goals is to keep the sphere of API as neat and consistency as possible. Strong enhancement always demands greater consensus.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.
